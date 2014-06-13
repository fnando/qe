require "spec_helper"

describe Qe::Worker do
  it "sets queue name" do
    HelloWorker.queue "hello"
    expect(HelloWorker.queue).to eql("hello")
  end

  it "returns options" do
    hello = HelloWorker.new(:a => 1)
    expect(hello.options).to include(:a => 1)
  end

  it "returns options as HashWithIndifferentAccess" do
    hello = HelloWorker.new("a" => 1)

    expect(hello.options[:a]).to eql(1)
    expect(hello.options["a"]).to eql(1)
  end

  it "delegates #enqueue to adapter" do
    adapter = double("adapter")
    expect(adapter)
      .to receive(:enqueue)
      .with(HelloWorker, :a => 1)

    Qe.adapter = adapter

    HelloWorker.enqueue(:a => 1)
  end

  it "delegates scheduling to adapter" do
    adapter = double("adapter")
    date = Time.now
    expect(adapter)
      .to receive(:schedule)
      .with(HelloWorker, date, :a => 1)

    Qe.adapter = adapter

    HelloWorker.enqueue(:a => 1, :run_at => date)
  end

  it "finds worker by its name" do
    worker = double("worker")
    stub_const "Some::Weird::Worker", worker

    expect(Qe::Worker.find("Some::Weird::Worker")).to eql(worker)
  end

  describe "#perform" do
    it "finds worker by its name" do
      expect(Qe::Worker)
        .to receive(:find)
        .with("HelloWorker")
        .and_return(HelloWorker)

      Qe::Worker.perform("HelloWorker", {})
    end

    it "initializes worker with provided options" do
      expect(HelloWorker)
        .to receive(:new)
        .with(:a => 1)
        .and_return(double.as_null_object)

      Qe::Worker.perform("HelloWorker", :a => 1)
    end

    it "performs job" do
      worker = HelloWorker.new({})
      allow(HelloWorker).to receive_messages :new => worker
      expect(worker).to receive(:before).ordered
      expect(worker).to receive(:perform).ordered
      expect(worker).to receive(:after).ordered

      Qe::Worker.perform("HelloWorker", {})
    end

    it "triggers default error handler" do
      allow_any_instance_of(HelloWorker).to receive(:perform).and_raise("ZOMG!")

      expect {
        Qe::Worker.perform("HelloWorker", {})
      }.to raise_error("ZOMG!")
    end

    it "passes error object to error handler" do
      expect_any_instance_of(HelloWorker)
        .to receive(:error)
        .with(kind_of(StandardError))

      allow_any_instance_of(HelloWorker)
        .to receive(:perform)
        .and_raise("ZOMG!")

      Qe::Worker.perform("HelloWorker", {})
    end
  end
end
