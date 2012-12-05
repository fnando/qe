require "spec_helper"

describe Qe::Beanstalk do
  it "sets adapter when loading file" do
    Qe.adapter = nil
    load "qe/beanstalk.rb"
    expect(Qe.adapter).to eql(Qe::Beanstalk)
  end

  context "worker" do
    it "performs job" do
      Qe::Worker
        .should_receive(:perform)
        .with(:a, :b, :c)

      Qe::Beanstalk::Worker.perform(:a, :b, :c)
    end
  end

  context "enqueuing" do
    let(:worker) {
      mock("worker", :queue => "some_queue", :name => "SomeWorker")
    }

    before do
      Backburner.stub :enqueue
    end

    it "sets queue name" do
      Qe::Beanstalk::Worker
        .should_receive(:queue)
        .with("some_queue")

      Qe::Beanstalk.enqueue(worker)
    end

    it "enqueues job" do
      ::Backburner
        .should_receive(:enqueue)
        .with(Qe::Beanstalk::Worker, "SomeWorker", :a => 1)

      Qe::Beanstalk.enqueue(worker, :a => 1)
    end
  end

  context "scheduling" do
    let(:worker) {
      mock("worker", :queue => "some_queue", :name => "SomeWorker")
    }

    let(:date) { Time.parse("2012-12-05 02:00:00") }

    before do
      Time.stub :now => date - 3600
      Backburner::Worker.stub :enqueue
    end

    it "sets queue name" do
      Qe::Beanstalk::Worker
        .should_receive(:queue)
        .with("some_queue")

      Qe::Beanstalk.schedule(worker, date, :a => 1)
    end

    it "schedules job" do
      ::Backburner::Worker
        .should_receive(:enqueue)
        .with(Qe::Beanstalk::Worker, ["SomeWorker", :a => 1], :delay => 3600)

      Qe::Beanstalk.schedule(worker, date, :a => 1)
    end
  end
end
