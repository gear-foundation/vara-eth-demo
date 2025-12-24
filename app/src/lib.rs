#![no_std]

use sails_rs::{cell::RefCell, prelude::*};

pub struct CounterData {
    counter: u32,
}

impl CounterData {
    pub const fn new(counter: u32) -> Self {
        Self { counter }
    }
}

#[event]
#[derive(Clone, Debug, PartialEq, Encode, TypeInfo)]
#[codec(crate = scale_codec)]
#[scale_info(crate = scale_info)]
pub enum CounterEvents {
    Added {
        #[indexed]
        source: ActorId,
        value: u32,
    },
    Subtracted {
        #[indexed]
        source: ActorId,
        value: u32,
    },
}

pub struct CounterService<'a> {
    data: &'a RefCell<CounterData>,
}

impl<'a> CounterService<'a> {
    pub fn new(data: &'a RefCell<CounterData>) -> Self {
        Self { data }
    }
}

#[service(events = CounterEvents)]
impl CounterService<'_> {
    #[export]
    pub fn add(&mut self, value: u32) -> u32 {
        let mut data_mut = self.data.borrow_mut();
        data_mut.counter = data_mut.counter.checked_add(value).expect("failed to add");
        let source = Syscall::message_source();
        self.emit_event(CounterEvents::Added { source, value })
            .expect("failed to emit gear event");
        self.emit_eth_event(CounterEvents::Added { source, value })
            .expect("failed to emit eth event");
        data_mut.counter
    }

    #[export]
    pub fn sub(&mut self, value: u32) -> u32 {
        let mut data_mut = self.data.borrow_mut();
        data_mut.counter = data_mut.counter.checked_sub(value).expect("failed to sub");
        let source = Syscall::message_source();
        self.emit_event(CounterEvents::Subtracted { source, value })
            .expect("failed to emit gear event");
        self.emit_eth_event(CounterEvents::Subtracted { source, value })
            .expect("failed to emit eth event");
        data_mut.counter
    }

    #[export]
    pub fn value(&self) -> u32 {
        self.data.borrow().counter
    }
}

pub struct Program {
    counter_data: RefCell<CounterData>,
}

#[program]
impl Program {
    pub fn init(counter: u32) -> Self {
        Self {
            counter_data: RefCell::new(CounterData::new(counter)),
        }
    }

    pub fn counter(&self) -> CounterService<'_> {
        CounterService::new(&self.counter_data)
    }
}
