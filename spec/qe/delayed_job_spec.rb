require "spec_helper"

describe Qe::DelayedJob do
  context "worker" do
    it "performs job" do
      job = Qe::DelayedJob::Worker.new("SomeWorker", :a => 1)

      Qe::Worker
        .should_receive(:perform)
        .with("SomeWorker", :a => 1)

      job.perform
    end
  end

  context "enqueuing" do
    let(:worker) {
      mock("worker", :queue => "some_queue", :name => "SomeWorker")
    }

    before do
      Delayed::Job.stub :enqueue
    end

    it "sets queue name" do
      Delayed::Job
        .should_receive(:enqueue)
        .with(anything, :queue => "some_queue")

      Qe::DelayedJob.enqueue(worker)
    end

    it "instantiates worker" do
      Qe::DelayedJob::Worker
        .should_receive(:new)
        .with("SomeWorker", :a => 1)

      Qe::DelayedJob.enqueue(worker, :a => 1)
    end

    it "enqueues job" do
      job = mock("job")
      Qe::DelayedJob::Worker.stub :new => job

      Delayed::Job
        .should_receive(:enqueue)
        .with(job, kind_of(Hash))

      Qe::DelayedJob.enqueue(worker, :a => 1)
    end
  end
end
