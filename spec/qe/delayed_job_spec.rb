require "spec_helper"

describe Qe::DelayedJob do
  it "sets adapter when loading file" do
    Qe::DelayedJob.class_eval { remove_const "Worker" }
    Qe.adapter = nil
    load "qe/delayed_job.rb"
    expect(Qe.adapter).to eql(Qe::DelayedJob)
  end

  context "worker" do
    it "performs job" do
      job = Qe::DelayedJob::Worker.new("SomeWorker", :a => 1)

      expect(Qe::Worker)
        .to receive(:perform)
        .with("SomeWorker", :a => 1)

      job.perform
    end
  end

  context "enqueuing" do
    let(:worker) {
      double("worker", :queue => "some_queue", :name => "SomeWorker")
    }

    before do
      allow(Delayed::Job).to receive(:enqueue)
    end

    it "sets queue name" do
      expect(Delayed::Job)
        .to receive(:enqueue)
        .with(anything, :queue => "some_queue")

      Qe::DelayedJob.enqueue(worker)
    end

    it "instantiates worker" do
      expect(Qe::DelayedJob::Worker)
        .to receive(:new)
        .with("SomeWorker", :a => 1)

      Qe::DelayedJob.enqueue(worker, :a => 1)
    end

    it "enqueues job" do
      job = double("job")
      expect(Qe::DelayedJob::Worker).to receive_messages(:new => job)

      expect(Delayed::Job)
        .to receive(:enqueue)
        .with(job, kind_of(Hash))

      Qe::DelayedJob.enqueue(worker, :a => 1)
    end
  end

  context "scheduling" do
    let(:worker) {
      double("worker", :queue => "some_queue", :name => "SomeWorker")
    }

    let(:date) { Time.now }

    before do
      allow(Delayed::Job).to receive :enqueue
    end

    it "sets queue name" do
      expect(Delayed::Job)
        .to receive(:enqueue)
        .with(anything, hash_including(:queue => "some_queue"))

      Qe::DelayedJob.schedule(worker, date, :a => 1)
    end

    it "instantiates worker" do
      expect(Qe::DelayedJob::Worker)
        .to receive(:new)
        .with("SomeWorker", :a => 1)

      Qe::DelayedJob.schedule(worker, date, :a => 1)
    end

    it "schedules job" do
      job = double("job")
      allow(Qe::DelayedJob::Worker).to receive_messages :new => job

      expect(Delayed::Job)
        .to receive(:enqueue)
        .with(job, hash_including(:run_at => date))

      Qe::DelayedJob.schedule(worker, date, :a => 1)
    end
  end
end
