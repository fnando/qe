require "spec_helper"

describe Qe::Resque do
  it "sets adapter when loading file" do
    Qe.adapter = nil
    load "qe/resque.rb"
    expect(Qe.adapter).to eql(Qe::Resque)
  end

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
      double("worker", :queue => "some_queue", :name => "SomeWorker")
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

  context "scheduling" do
    let(:date) { Time.now }

    let(:worker) {
      double("worker", :queue => "some_queue", :name => "SomeWorker")
    }

    before do
      Resque.stub :enqueue_at => nil, :remove_delayed => nil
    end

    it "sets queue name" do
      Qe::Resque.schedule(worker, date)
      expect(Qe::Resque::Worker.instance_variable_get("@queue")).to eql("some_queue")
    end

    it "schedules job" do
      ::Resque
        .should_receive(:enqueue_at)
        .with(date, Qe::Resque::Worker, "SomeWorker", :a => 1)

      Qe::Resque.schedule(worker, date, :a => 1)
    end
  end
end
