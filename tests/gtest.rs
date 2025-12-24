use sails_rs::{client::*, gtest::*, prelude::*};
use vara_eth_demo_client::{VaraEthDemoClient, VaraEthDemoClientCtors, counter::*};

const ACTOR_ID: u64 = 42;

#[tokio::test]
async fn do_something_works() {
    let system = System::new();
    system.init_logger_with_default_filter("gwasm=debug,gtest=info,sails_rs=debug");
    system.mint_to(ACTOR_ID, 100_000_000_000_000);
    let program_code_id = system.submit_code(vara_eth_demo::WASM_BINARY);

    let env = GtestEnv::new(system, ACTOR_ID.into());

    let program = env
        .deploy::<vara_eth_demo_client::VaraEthDemoClientProgram>(program_code_id, b"salt".to_vec())
        .init(5)
        .await
        .unwrap();

    let mut counter_service_client = program.counter();

    assert_eq!(counter_service_client.value().await.unwrap(), 5);

    assert_eq!(counter_service_client.add(37).await.unwrap(), 42);
    assert_eq!(counter_service_client.value().await.unwrap(), 42);

    assert_eq!(counter_service_client.add(42).await.unwrap(), 84);
    assert_eq!(counter_service_client.value().await.unwrap(), 84);

    assert_eq!(counter_service_client.sub(42).await.unwrap(), 42);
    assert_eq!(counter_service_client.value().await.unwrap(), 42);

    assert_eq!(
        counter_service_client.add(u32::MAX).await,
        Err(GtestError::ReplyHasError(
            ErrorReplyReason::Execution(SimpleExecutionError::UserspacePanic),
            "panicked with 'failed to add'".into(),
        )),
    );

    assert_eq!(
        counter_service_client.sub(u32::MAX).await,
        Err(GtestError::ReplyHasError(
            ErrorReplyReason::Execution(SimpleExecutionError::UserspacePanic),
            "panicked with 'failed to sub'".into(),
        )),
    );
}
