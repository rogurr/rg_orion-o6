# Rust DXE Driver `.efi` Size Investigation

Investigation notes on why `HelloWorldRustDxe.efi` grew from ~6 KB to ~16 KB after a
seemingly minor source change. All numbers below were measured on the machine described
under [Environment](#environment); nothing is estimated unless explicitly labelled.

---

## Environment

| item | value |
|---|---|
| toolchain | `rustc 1.96.0-nightly (9602bda1d 2026-04-05)` |
| LLVM | 22.1.2 |
| host | `x86_64-unknown-linux-gnu` |
| target | `aarch64-unknown-uefi` |
| cargo | `1.96.0-nightly (888f67534 2026-03-30)` |
| sysroot | `/home/rogurr/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu` |
| crate | `bootchain/modules/uefi/RustHelloWorld` |

Two build outputs were compared, both produced by the EDK2 build infrastructure with
only `src/main.rs` differing:

- `bootchain/RRR/Default/RustHelloWorld/DEBUG/HelloWorldRustDxe.efi` — 6,656 bytes
- `bootchain/RRR/Test1/RustHelloWorld/DEBUG/HelloWorldRustDxe.efi` — 16,384 bytes

---

## Question 1

> If you do a diff between the two open main.rs files, you will see that one has a
> structure and enum defined and just a bunch more debug prints. Nothing significant.
>
> But if you look at the resulting .efi files once compiled, the
> `./bootchain/RRR/Test1/RustHelloWorld/DEBUG/HelloWorldRustDxe.efi` file is about 16KB
> in size, but the `./bootchain/RRR/Default/RustHelloWorld/DEBUG/HelloWorldRustDxe.efi`
> file is only about 6KB.
>
> They were both compiled using this UEFI build infrastructure and the .rs file was the
> only thing that changed. Can you help me understand why it is so much larger?

### Answer

Verified with hard data from the two `.map` files and the PE headers. Nothing about the
build infra changed — the source change instantiated a large chunk of `core::fmt`.

#### Measured facts

PE sections (parsed directly from the `.efi` files):

| section | Default | Test1 | delta |
|---|---|---|---|
| `.text` | 3,700 | 12,188 | **+8,488** |
| `.rdata` | 471 | 1,859 | +1,388 |
| `.data` | 56 | 56 | 0 |
| `.reloc` | 52 | 100 | +48 |
| **file** | **6,656** | **16,384** | (FileAlign 0x200, SectionAlign 0x1000) |

`.text` symbol count went 17 → 61. Attributing the 8,488 new `.text` bytes by
originating crate:

- **6,504 bytes from `libcore`** (newly linked `core::fmt` code)
- ~772 bytes from the driver crate (generated `Debug` impls / monomorphizations)

#### Where the libcore bytes went

Grouped from the map diff:

| group | bytes | triggered by |
|---|---|---|
| `Debug` builders + pretty-print | ~3,048 | `{:?}` and `{:#?}` |
| integer `Display` + `pad_integral` | ~2,476 | `{}` on u8/u16/u32/u64/usize |
| `LowerHex`/`UpperHex` | ~804 | `{:x}`, `{:08x}`, `{:#010x}` |
| pointer formatting | ~184 | `{:p}` |

Single largest individual symbols:

- `core::fmt::Formatter::pad_integral` — **960 bytes**, pulled in by the first integer
  `{}` or `{:x}`
- `core::fmt::builders::PadAdapter::write_str` — **576 bytes**, this is the
  indent-injection engine used *only* by `{:#?}`
- `DebugStruct::field` (424), `debug_tuple_field1_finish` (360), `DebugTuple::field`
  (312), `DebugList::entry` (308), `debug_struct_field3_finish` (296)
- Separate `num::imp::<T>::Display::fmt` bodies for u32 (308), u64 (308), usize (300),
  u16 (256), u8 (164) — these are **not shared**; each width is a distinct
  monomorphization
- Seven separate `LowerHex`/`UpperHex` bodies, 112–116 bytes each, again one per integer
  width

#### Why it's disproportionate

The Default build's only log call is `log::info!("[XXXXXXXX] Test Rust Driver")` — a
literal-only format string with zero runtime arguments. It links `core::fmt::write` and
`Formatter::pad` (needed by log's `Level: Display`) and nothing else. It never touches
the formatting *value* machinery at all.

The moment you add the first `{}` on an integer, you pay a large fixed entry cost
(`pad_integral`, ~1 KB) plus a per-integer-width cost. `{:x}` adds another per-width
family. `{:?}` adds the builder framework. `{:#?}` adds `PadAdapter` on top of that. So
the build crossed from "no formatting" to "essentially all of `core::fmt`" in one step.

The struct and enum definitions themselves cost almost nothing — their derived
`Debug::fmt` bodies are only 136 and 144 bytes. The cost is the shared machinery they
call into.

#### Notes on the build config

`bootchain/modules/uefi/RustHelloWorld/Cargo.toml` already sets
`[profile.dev] opt-level = "s"`, and the artifact path confirms the `debug` profile.

[Inference] Since this is still the dev profile, `debug-assertions` and `overflow-checks`
are on by default and there's no LTO, which inflates these numbers somewhat — but the
monomorphization count is the dominant factor, not the optimization level.

[Inference, based on the per-symbol sizes above] If you want to trim it: dropping just
`{:#?}` should recover roughly 700 bytes (`PadAdapter::write_str` + `write_char`);
restricting all integer formatting to a single width (e.g. cast everything to `u64`)
should recover most of the ~1.6 KB spent on duplicate per-width
`Display`/`LowerHex`/`UpperHex` bodies. Neither of those variants was measured at this
point, so treat those two figures as estimates.

---

## Question 2

> Where does the Debug builders and pretty-print get ingested? My Cargo.toml file only
> has the uart, log, and spin crates defined.

### Answer

It comes from `core`, which is not and cannot be a Cargo dependency.

#### The chain, verified

**1. `core` is linked implicitly.** A `#![no_std]` crate gets `core` injected by the
compiler, not by Cargo. It ships precompiled as part of the `rust-std` component for the
target:

```
~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/aarch64-unknown-uefi/lib/libcore-51f92e4ab864d16a.rlib
```

That hash is the proof — the map file attributes every one of those symbols to
`libcore-51f92e4ab864d16a`, and it matches this rlib in the filename. Grepping the
archive directly found `PadAdapter::write_str`, `DebugStruct::field`, and
`Formatter::pad_integral` defined inside it.

**2. `#[derive(Debug)]` emits calls into `core::fmt::builders`.** Expanding the exact
struct with `rustc -Zunpretty=expanded`:

```rust
#[automatically_derived]
impl ::core::fmt::Debug for DriverInfo {
    #[inline]
    fn fmt(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
        ::core::fmt::Formatter::debug_struct_field3_finish(f, "DriverInfo",
            "uart_base", &self.uart_base, "revision", &self.revision,
            "enabled", &&self.enabled)
    }
}
```

`debug_struct_field3_finish` is precisely the 296-byte symbol in the diff. The 136-byte
derived impl is just this shim; the real weight is the `core` function it calls.

**3. `{:#?}` pulls in `PadAdapter`.** From the actual core source in the sysroot,
`lib/rustlib/src/rust/library/core/src/fmt/builders.rs`:

```rust
fn is_pretty(&self) -> bool {
    self.fmt.alternate()
}
...
if self.is_pretty() {
    let mut writer = PadAdapter::wrap(self.fmt, &mut slot, &mut state);
```

The `#` in `{:#?}` sets the alternate flag, and `DebugStruct`/`DebugTuple`/`DebugList`
each branch into `PadAdapter` to inject per-line indentation. That's the 576-byte
`PadAdapter::write_str` plus the 128-byte `write_char`.

#### Why the size only appeared now

Rust rlibs link like static archives — the linker only pulls in the object files whose
symbols are actually referenced. The Default build referenced almost nothing from
`core::fmt`'s value machinery, so almost none of `libcore` was pulled in, even though the
full 2.2 MB rlib was on the link line both times. `core` was always there; Test1 just
started reaching into it.

So there is nothing to remove from `Cargo.toml` — the growth is entirely `core`, governed
by which formatting features the source uses.

---

## Question 3

> What switches does core have to help reduce this size? 3K just for string formatting
> seems excessive, are there ways to shrink that?

### Answer

`core` has exactly **two** size knobs, and neither is a plain rustc flag — both require
recompiling `core` from source. Everything below was measured in an isolated scratch
crate (`/tmp/szlab`); the real tree was not touched.

#### Measured results — Test1 source

| bytes | configuration |
|---:|---|
| **16,384** | current build (dev, `opt-level="s"`) |
| 14,848 | dev + `-Zfmt-debug=shallow` |
| 11,776 | dev + `-Zfmt-debug=none` |
| 26,112 | dev + `-Zbuild-std` ← **worse** |
| 22,016 | dev + `-Zbuild-std` + `optimize_for_size` ← **worse** |
| 14,336 | release (`opt-level="z"`, `lto`, `codegen-units=1`) |
| 12,800 | release + `-Zbuild-std` |
| 11,776 | release + `-Zbuild-std` + `optimize_for_size` |
| 11,776 | ^ + `panic = "immediate-abort"` |
| **8,192** | ^ + `-Zfmt-debug=none` |

Default (small) source under that last config: **4,608** bytes.

#### The two core switches

Confirmed in `library/core/Cargo.toml` in the sysroot:

```
panic_immediate_abort = []
optimize_for_size = []
```

**`optimize_for_size`** — swaps in smaller/slower algorithms. It touches `fmt/num.rs`
(integer `Display`) and `str/count.rs`, but `fmt/builders.rs` has **zero**
`optimize_for_size` hits. So it does nothing for the ~3 KB Debug-builder group.

**`panic_immediate_abort`** is gone in this toolchain; it's now a panic strategy.
Requires `cargo-features = ["panic-immediate-abort"]` at the top of `Cargo.toml` plus
`panic = "immediate-abort"` in the profile, and it still needs `-Zbuild-std`. It measured
0 bytes of savings here — [Inference] likely because the `loop {}` panic handler already
suppresses the formatting path.

**`-Zfmt-debug=none`** is the single biggest lever (−4,608 bytes), but it is a
*functional* change: `{:?}` compiles to nothing, so struct/enum dumps print empty.
`shallow` (type names only) is the middle ground. The flag's own help text:

```
-Z fmt-debug=val -- how detailed `#[derive(Debug)]` should be. `full` prints types
recursively, `shallow` prints only type names, `none` prints nothing and disables
`{:?}`. (default: `full`)
```

#### Two traps worth knowing

1. **`-Zbuild-std` on the dev profile backfires** — 16,384 → 26,112. Building `core`
   yourself under `[profile.dev]` turns on `debug-assertions` and `overflow-checks`
   *inside core*, which the precompiled sysroot copy does not have. Only use build-std
   with a release-style profile.
2. **`do_count_chars` is 1,516 bytes — 41% of the 3,700-byte baseline `.text`**, present
   even in the "small" build. It's the SWAR char-counting routine reached via
   `Formatter::pad`. It's gated by `optimize_for_size`, so build-std shrinks the floor
   too.

Top symbols in the *Default* (6,656-byte) build, for reference:

```
  1516  core::str::count::do_count_chars
   788  core::fmt::Formatter::pad
   436  core::fmt::write
   220  efi_main
   176  <SimpleLogger as log::Log>::log
   160  <Uart as core::fmt::Write>::write_char
   112  log::set_logger
    84  log::__private_api::log::<GlobalLogger>
```

#### On "3 KB seems excessive"

That's inherent to `core::fmt`, not a misconfiguration. It's a runtime-dispatched engine
carrying width/precision/alignment/sign/padding handling and `&dyn Debug` vtables, and
each integer width gets its own monomorphized body. Dead-code elimination already removed
everything unreferenced — what's left is genuinely what `{:x}`/`{:?}`/`{:#?}` need.

[Unverified — not tested here] If you want to go materially below ~8 KB while keeping
real output, the usual route is to bypass `core::fmt` with hand-rolled hex/decimal
writers or a crate like `ufmt`, which drops padding/precision support in exchange for
much smaller code.

---

## Reproducing the measurements

All commands below are written to be run from the repository root — the same directory
this file lives in.

### PE section sizes

```bash
cd bootchain/RRR
python3 - <<'PY'
import struct
def pe(p):
    b=open(p,'rb').read()
    e=struct.unpack_from('<I',b,0x3c)[0]
    nsec=struct.unpack_from('<H',b,e+6)[0]
    optsz=struct.unpack_from('<H',b,e+20)[0]
    opt=e+24
    fa=struct.unpack_from('<I',b,opt+36)[0]
    sa=struct.unpack_from('<I',b,opt+32)[0]
    print(f"\n{p}  filesize={len(b)}  SectionAlign=0x{sa:x} FileAlign=0x{fa:x}")
    print(f"  {'name':10}{'VSize':>10}{'RawSize':>10}{'RawPtr':>10}")
    st=opt+optsz
    for i in range(nsec):
        o=st+i*40
        n=b[o:o+8].rstrip(b'\0').decode()
        vs,va,rs,rp=struct.unpack_from('<IIII',b,o+8)
        print(f"  {n:10}{vs:10d}{rs:10d}{rp:10d}")
for f in ('Default','Test1'):
    pe(f'{f}/RustHelloWorld/DEBUG/HelloWorldRustDxe.efi')
PY
```

### Per-symbol `.text` diff between the two map files

```bash
cd bootchain/RRR
python3 - <<'PY'
import re, collections

def parse(p):
    syms=[]
    for line in open(p, errors='replace'):
        m=re.match(r'\s*(\d{4}):([0-9a-fA-F]{8})\s+(\S+)\s+([0-9a-fA-F]{16})\s+(\S+)', line)
        if m:
            sec,off,name,rva,obj=m.groups()
            syms.append((sec,int(off,16),name,obj))
    return syms

def textsizes(p):
    syms=[s for s in parse(p) if s[0]=='0001']
    byoff={}
    for sec,off,name,obj in syms:
        byoff.setdefault(off,(name,obj))
    offs=sorted(byoff)
    end=0
    for line in open(p,errors='replace'):
        m=re.match(r'\s*0001:00000000 ([0-9a-fA-F]+)H \.text',line)
        if m: end=int(m.group(1),16)
    out={}
    for i,o in enumerate(offs):
        nxt = offs[i+1] if i+1<len(offs) else end
        name,obj=byoff[o]
        out[name]=(nxt-o,obj)
    return out

d=textsizes('Default/RustHelloWorld/DEBUG/HelloWorldRustDxe.map')
t=textsizes('Test1/RustHelloWorld/DEBUG/HelloWorldRustDxe.map')
print(f"Default .text symbols: {len(d)}  total {sum(v[0] for v in d.values())}")
print(f"Test1   .text symbols: {len(t)}  total {sum(v[0] for v in t.values())}")
new=[(v[0],k,v[1]) for k,v in t.items() if k not in d]
new.sort(reverse=True)
print(f"\n--- symbols ONLY in Test1 ({len(new)}), by .text size ---")
for sz,name,obj in new[:45]:
    lib=obj.split(':')[0]
    print(f"{sz:7d}  {name[:110]}   [{lib[:30]}]")
print("\n--- grouped by originating crate/lib ---")
g=collections.Counter()
for sz,name,obj in new:
    g[obj.split(':')[0].split('-')[0]]+=sz
for k,v in g.most_common():
    print(f"{v:7d}  {k}")
PY
```

Output of the grouping step:

```
   6504  libcore
    932  HelloWorldRustDxe
```

> Caveat: one 160-byte entry (`<Uart as core::fmt::Write>::write_char`) shows as
> "only in Test1" but is present in both builds; its mangled name carries a differing
> `.llvm.<hash>` suffix. The `HelloWorldRustDxe` group total is therefore ~772 bytes of
> genuinely new code, not 932.

### Confirming the symbols live in the precompiled `libcore`

```bash
CORE="$(rustc --print sysroot)/lib/rustlib/aarch64-unknown-uefi/lib/libcore-51f92e4ab864d16a.rlib"
for s in \
  _RNvXs0_NtNtCshY7GFnqGkdJ_4core3fmt8buildersNtB5_10PadAdapterNtB7_5Write9write_str \
  _RNvMs1_NtNtCshY7GFnqGkdJ_4core3fmt8buildersNtB5_11DebugStruct5field \
  _RNvMsa_NtCshY7GFnqGkdJ_4core3fmtNtB5_9Formatter12pad_integral ; do
  printf '%-8s %s\n' "$(grep -c "$s" "$CORE" >/dev/null 2>&1 && echo FOUND || echo MISSING)" "$s"
done
```

All three report `FOUND`.

### Showing the derive expansion

```bash
cd /tmp && cat > dbg_expand.rs <<'EOF'
#[derive(Debug)]
struct DriverInfo { uart_base: usize, revision: u32, enabled: bool }
EOF
rustc -Zunpretty=expanded --edition 2024 --crate-type lib dbg_expand.rs
```

### Size matrix

Scratch crate built from `RRR/Test1/main.rs` plus the real `Cargo.toml`, with this
profile appended:

```toml
cargo-features = ["panic-immediate-abort"]

[profile.release]
  opt-level = "z"
  lto = true
  codegen-units = 1
  panic = "immediate-abort"
  debug = false
```

```bash
rm -rf /tmp/szlab && mkdir -p /tmp/szlab/src
cp bootchain/RRR/Test1/main.rs /tmp/szlab/src/main.rs
cp bootchain/modules/uefi/RustHelloWorld/Cargo.toml /tmp/szlab/Cargo.toml
cd /tmp/szlab

# dev-profile variants
cargo build --target aarch64-unknown-uefi --target-dir /tmp/szlab/base
RUSTFLAGS="-Zfmt-debug=shallow" cargo build --target aarch64-unknown-uefi --target-dir /tmp/szlab/sh
RUSTFLAGS="-Zfmt-debug=none"    cargo build --target aarch64-unknown-uefi --target-dir /tmp/szlab/no

# release + build-std variants (after appending the profile above)
BS=(-Zbuild-std=core,compiler_builtins -Zbuild-std-features=optimize_for_size)
cargo build --release --target aarch64-unknown-uefi --target-dir /tmp/szlab/p1 "${BS[@]}"
RUSTFLAGS="-Zfmt-debug=none" \
  cargo build --release --target aarch64-unknown-uefi --target-dir /tmp/szlab/p2 "${BS[@]}"
```

`-Zbuild-std` requires the `rust-src` rustup component, which is installed on this
machine (verified — `lib/rustlib/src/rust/library/core/` is present).

---

## Summary for the reader

1. The `.efi` grew because the new `main.rs` reaches into `core::fmt` for the first time.
   6,504 of the 8,488 new `.text` bytes come from the precompiled `libcore` rlib.
2. The struct/enum definitions are irrelevant to the size; their derived `Debug` impls
   total 280 bytes. The `core` machinery they call is the cost.
3. `core` is not in `Cargo.toml` and never will be — it's injected by the compiler and
   shipped precompiled in the sysroot. Linking is per-object, which is why the small
   build stayed small.
4. Realistic reductions, all measured: release profile + `-Zbuild-std` with
   `optimize_for_size` gets 16,384 → 11,776 with no behaviour change. Adding
   `-Zfmt-debug=none` reaches 8,192 but silently disables all `{:?}` output.
