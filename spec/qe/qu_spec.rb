require "spec_helper"

describe Qe::Qu do
  context "worker" do
    it "performs job" do
      Qe::Worker
        .should_receive(:perform)
        .with(:a, :b, :c)

      Qe::Qu::Worker.perform(:a, :b, :c)
    end
  end

  context "enqueuing" do
    let(:worker) {
      mock("worker", :queue => "some_queue", :name => "SomeWorker")
    }

    before do
      Qu.stub :enqueue
    end

    it "sets queue name" do
      Qe::Qu.enqueue(worker)
      expect(Qe::Qu::Worker.instance_variable_get("@queue")).to eql("some_queue")
    end

    it "enqueues job" do
      ::Qu
        .should_receive(:enqueue)
        .with(Qe::Qu::Worker, "SomeWorker", :a => 1)

      Qe::Qu.enqueue(worker, :a => 1)
    end
  end
end
