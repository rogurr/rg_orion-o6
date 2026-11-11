//! Radxa Orion O6 platform entry point, adapted from the ODP Radxa platform.
//!
//! SPDX-License-Identifier: MIT

#![no_std]
#![no_main]

use core::{ffi::c_void, fmt::Write, panic::PanicInfo};
use patina::serial::uart::UartPl011;
use patina_dxe_core::{ComponentInfo, Core, CpuInfo, GicBases, MemoryInfo, PlatformInfo};
use patina_ffs_extractors::CompositeSectionExtractor;

const UART_BASE: usize = 0x040d_0000;
const GICD_BASE: u64 = 0x0e01_0000;
const GICR_BASE: u64 = 0x0e09_0000;

struct SerialWriter;

impl Write for SerialWriter {
    fn write_str(&mut self, text: &str) -> core::fmt::Result {
        let uart = UartPl011::new(UART_BASE);
        for byte in text.bytes() {
            uart.write_byte(byte);
        }
        Ok(())
    }
}

struct SerialLogger;

impl log::Log for SerialLogger {
    fn enabled(&self, metadata: &log::Metadata) -> bool {
        metadata.level() <= log::Level::Info
    }

    fn log(&self, record: &log::Record) {
        if self.enabled(record.metadata()) {
            writeln!(
                SerialWriter,
                "[Patina {}] {}\r",
                record.level(),
                record.args()
            )
            .unwrap();
        }
    }

    fn flush(&self) {}
}

static LOGGER: SerialLogger = SerialLogger;

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    log::error!("{info}");
    loop {
        core::hint::spin_loop();
    }
}

struct RadxaO6;

impl MemoryInfo for RadxaO6 {}
impl ComponentInfo for RadxaO6 {}

impl CpuInfo for RadxaO6 {
    fn gic_bases() -> GicBases {
        // These are the Sky1 MMIO bases used by the stock O6 DSC.
        unsafe { GicBases::new(GICD_BASE, GICR_BASE) }
    }
}

impl PlatformInfo for RadxaO6 {
    type CpuInfo = Self;
    type MemoryInfo = Self;
    type ComponentInfo = Self;
    type Extractor = CompositeSectionExtractor;
}

static CORE: Core<RadxaO6> = Core::new(CompositeSectionExtractor::new());

#[unsafe(export_name = "efi_main")]
pub extern "efiapi" fn entry_point(physical_hob_list: *const c_void) -> ! {
    log::set_logger(&LOGGER).expect("Patina logger already initialized");
    log::set_max_level(log::LevelFilter::Info);
    log::info!("DXE Core Platform Binary Entry");
    CORE.entry_point(physical_hob_list);
}
