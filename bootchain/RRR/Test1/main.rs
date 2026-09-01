//! Hello World Rust DXE Driver
//!
//! Demonstrates how to build a DXE driver written in Rust.
//!
//! ## License
//!
//! Copyright (c) Microsoft Corporation. All rights reserved.
//!
//! SPDX-License-Identifier: BSD-2-Clause-Patent
//!

#![cfg(target_os = "uefi")]
#![no_std]
#![no_main]

use arm_pl011_uart::{PL011Registers, Uart, UniqueMmioPointer};
use core::{ffi::c_void, fmt::Write, panic::PanicInfo, ptr::NonNull};
use spin::Mutex;

#[derive(Debug)]
struct DriverInfo {
    uart_base: usize,
    revision:  u32,
    enabled:   bool,
}

#[derive(Debug)]
enum DriverState {
    Uninitialized,
    Ready { base: usize },
    Faulted(u32),
}

const UART_BASE: usize = 0x040D_0000;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

//
// Simple logger implementation using UART
//

struct SimpleLogger {
    uart: Mutex<Option<Uart<'static>>>,
}

impl SimpleLogger {
    const fn new() -> Self {
        Self {
            uart: Mutex::new(None),
        }
    }

    fn init(&self) {
        let registers = NonNull::new(UART_BASE as *mut PL011Registers).unwrap();
        // SAFETY: UART_BASE is UART3's MMIO register block and access is serialized by the mutex.
        let registers = unsafe { UniqueMmioPointer::new(registers) };
        *self.uart.lock() = Some(Uart::new(registers));
    }
}

impl log::Log for SimpleLogger {
    fn enabled(&self, _metadata: &log::Metadata) -> bool {
        true
    }

    fn log(&self, record: &log::Record) {
        if self.enabled(record.metadata()) {
            if let Some(uart) = self.uart.lock().as_mut() {
                let _ = writeln!(uart, "[Rust {}] {}\r", record.level(), record.args());
            }
        }
    }

    fn flush(&self) {}
}

static LOGGER: SimpleLogger = SimpleLogger::new();

//
// Primary entry point
//

#[unsafe(no_mangle)]
pub extern "efiapi" fn efi_main(_image_handle: *mut c_void, _system_table: *mut c_void) -> usize {
    LOGGER.init();

    let _ = log::set_logger(&LOGGER).map(|()| log::set_max_level(log::LevelFilter::Debug));
    log::info!("[XXXXXXXX] Test Rust Driver");

    // --- Decimal / signed integer formatting ---
    let val_u8: u8 = 0xAB;
    let val_u16: u16 = 0xBEEF;
    let val_u32: u32 = 0xDEAD_BEEF;
    let val_u64: u64 = 0xCAFE_BABE_DEAD_BEEF;
    let val_i8: i8 = -42_i8;
    let val_i32: i32 = -123_456_i32;
    let val_i64: i64 = i64::MIN;
    let val_usize: usize = usize::MAX;

    log::debug!("[fmt:dec  ] u8={} u16={} u32={} u64={} usize={}", val_u8, val_u16, val_u32, val_u64, val_usize);

    // --- Hexadecimal formatting (lower and upper) ---
    log::debug!("[fmt:hex  ] u8={:x} u16={:x} u32={:08x} u64={:016x}", val_u8, val_u16, val_u32, val_u64);
    log::debug!("[fmt:0x   ] u32={:#010x} u64={:#018x}", val_u32, val_u64);

    // --- Pointer formatting ---
    let ptr = UART_BASE as *const u8;
    log::debug!("[fmt:ptr  ] uart_base={:p}", ptr);

    // --- Boolean and char ---
    log::debug!("[fmt:bool ] flag={} not_flag={}", true, false);

    // --- Debug trait (non-pretty) ---
    log::debug!("[fmt:dbg  ] val={:?} pair={:?} arr={:?}", val_u32, (val_u8, val_i32), [1_u32, 2, 3]);

    // --- Debug trait (pretty-print) ---
    log::debug!("[fmt:pdbg ] pretty={:#?}", (val_u32, val_u64));

    // --- Debug on derived struct ---
    let info = DriverInfo { uart_base: UART_BASE, revision: 1, enabled: true };
    log::debug!("[fmt:struct] {:?}", info);
    log::debug!("[fmt:pstruct] {:#?}", info);

    // --- Debug on derived enum ---
    let state = DriverState::Ready { base: UART_BASE };
    log::debug!("[fmt:enum  ] {:?} {:?}", DriverState::Uninitialized, state);
    log::debug!("[fmt:penum ] {:#?}", state);

    0
}
