require "spec_helper"

describe Qe::Resque do
  context "worker" do
    it "performs job" do
      Qe::Worker
        .should_receive(:perform)
        .with(:a, :b, :c)

      Qe::Resque::Worker.perform(:a, :b, :c)
    end
  end

  context "enqueuing" do
    let(:worker) {
      mock("worker", :queue => "some_queue", :name => "SomeWorker")
    }

    before do
      Resque.stub :enqueue
    end

    it "sets queue name" do
      Qe::Resque.enqueue(worker)
      expect(Qe::Resque::Worker.instance_variable_get("@queue")).to eql("some_queue")
    end

    it "enqueues job" do
      ::Resque
        .should_receive(:enqueue)
        .with(Qe::Resque::Worker, "SomeWorker", :a => 1)

      Qe::Resque.enqueue(worker, :a => 1)
    end
  end
end
