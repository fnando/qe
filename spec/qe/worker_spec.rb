require "spec_helper"

describe Qe::Worker do
  it "sets queue name" do
    HelloWorker.queue "hello"
    expect(HelloWorker.queue).to eql("hello")
  end

  it "returns options" do
    hello = HelloWorker.new(:a => 1)
    expect(hello.options).to eql(:a => 1)
  end

  it "delegates #enqueue to adapter" do
    adapter = mock("adapter")
    adapter
      .should_receive(:enqueue)
      .with(HelloWorker, :a => 1)

    Qe.adapter = adapter

    HelloWorker.enqueue(:a => 1)
  end

  it "delegates scheduling to adapter" do
    adapter = mock("adapter")
    date = Time.now
    adapter
      .should_receive(:schedule)
      .with(HelloWorker, date, :a => 1)

    Qe.adapter = adapter

    HelloWorker.enqueue(:a => 1, :run_at => date)
  end

  it "finds worker by its name" do
    worker = mock("worker")
    stub_const "Some::Weird::Worker", worker

    expect(Qe::Worker.find("Some::Weird::Worker")).to eql(worker)
  end

  describe "#perform" do
    it "finds worker by its name" do
      Qe::Worker
        .should_receive(:find)
        .with("HelloWorker")
        .and_return(HelloWorker)

      Qe::Worker.perform("HelloWorker", {})
    end

    it "initializes worker with provided options" do
      HelloWorker
        .should_receive(:new)
        .with(:a => 1)
        .and_return(mock.as_null_object)

      Qe::Worker.perform("HelloWorker", :a => 1)
    end

    it "performs job" do
      worker = HelloWorker.new({})
      HelloWorker.stub :new => worker
      worker.should_receive(:before).ordered
      worker.should_receive(:perform).ordered
      worker.should_receive(:after).ordered

      Qe::Worker.perform("HelloWorker", {})
    end

    it "triggers default error handler" do
      HelloWorker.any_instance.stub(:perform).and_raise("ZOMG!")

      expect {
        Qe::Worker.perform("HelloWorker", {})
      }.to raise_error("ZOMG!")
    end

    it "passes error object to error handler" do
      HelloWorker.any_instance
        .should_receive(:error)
        .with(kind_of(StandardError))

      HelloWorker.any_instance
        .stub(:perform)
        .and_raise("ZOMG!")

      Qe::Worker.perform("HelloWorker", {})
    end
  end
end
