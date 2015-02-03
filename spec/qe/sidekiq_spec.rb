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
      expect(Qe::Worker)
        .to receive(:perform)
        .with(:a, :b, :c)

      Qe::Sidekiq::Worker.new.perform(:a, :b, :c)
    end
  end

  context "enqueuing" do
    let(:worker) {
      double("worker", :queue => "some_queue", :name => "SomeWorker", :options => {})
    }

    before do
      allow(Qe::Sidekiq::Worker).to receive :perform_async
    end

    it "sets queue name" do
      expect(Qe::Sidekiq::Worker).to  receive(:sidekiq_options)
                                          .with(:queue => "some_queue")

      Qe::Sidekiq.enqueue(worker)
    end

    it "enqueues job" do
      expect(Qe::Sidekiq::Worker).to receive(:perform_async)
                                        .with("SomeWorker", :a => 1)

      Qe::Sidekiq.enqueue(worker, :a => 1)
    end

    it "sets options" do
      worker = Class.new do
        include Qe::Worker
        options :retry => false
      end

      expect(Qe::Sidekiq::Worker).to  receive(:sidekiq_options)
                                        .with(hash_including(:retry => false))
      Qe::Sidekiq.enqueue(worker)
    end
  end

  context "scheduling" do
    let(:worker) {
      double("worker", :queue => "some_queue", :name => "SomeWorker", :options => {})
    }

    before do
      allow(Qe::Sidekiq::Worker).to receive(:perform_at)
    end

    it "sets queue name" do
      expect(Qe::Sidekiq::Worker).to receive(:sidekiq_options)
                                        .with(:queue => "some_queue")

      Qe::Sidekiq.schedule(worker, Time.now)
    end

    it "schedules job" do
      date = Time.now

      expect(Qe::Sidekiq::Worker).to receive(:perform_at)
                                        .with(date, "SomeWorker", :a => 1)

      Qe::Sidekiq.schedule(worker, date, :a => 1)
    end

    it "sets options" do
      Qe.adapter = Qe::Sidekiq

      worker = Class.new do
        include Qe::Worker
        options :retry => false
      end

      expect(Qe::Sidekiq::Worker).to  receive(:sidekiq_options)
                                        .with(hash_including(:retry => false))
      Qe::Sidekiq.schedule(worker, Time.now)
    end
  end
end
