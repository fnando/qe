require "spec_helper"

describe Qe::Sidekiq do
  it "sets adapter when loading file" do
    Qe.adapter = nil
    load "qe/sidekiq.rb"
    expect(Qe.adapter).to eql(Qe::Sidekiq)
  end

  context "worker" do
    it "includes Sidekiq::Worker" do
      expect(Qe::Sidekiq::Worker.included_modules).to include(Sidekiq::Worker)
    end

    it "performs job" do
      Qe::Worker
        .should_receive(:perform)
        .with(:a, :b, :c)

      Qe::Sidekiq::Worker.new.perform(:a, :b, :c)
    end
  end

  context "enqueuing" do
    let(:worker) {
      double("worker", :queue => "some_queue", :name => "SomeWorker")
    }

    before do
      Qe::Sidekiq::Worker.stub :perform_async
    end

    it "sets queue name" do
      Qe::Sidekiq::Worker
        .should_receive(:sidekiq_options)
        .with(:queue => "some_queue")

      Qe::Sidekiq.enqueue(worker)
    end

    it "enqueues job" do
      Qe::Sidekiq::Worker
        .should_receive(:perform_async)
        .with("SomeWorker", :a => 1)

      Qe::Sidekiq.enqueue(worker, :a => 1)
    end
  end

  context "scheduling" do
    let(:worker) {
      double("worker", :queue => "some_queue", :name => "SomeWorker")
    }

    before do
      Qe::Sidekiq::Worker.stub :perform_at
    end

    it "sets queue name" do
      Qe::Sidekiq::Worker
        .should_receive(:sidekiq_options)
        .with(:queue => "some_queue")

      Qe::Sidekiq.enqueue(worker)
    end

    it "schedules job" do
      date = Time.now

      Qe::Sidekiq::Worker
        .should_receive(:perform_at)
        .with(date, "SomeWorker", :a => 1)

      Qe::Sidekiq.schedule(worker, date, :a => 1)
    end
  end
end
