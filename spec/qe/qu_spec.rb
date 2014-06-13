require "spec_helper"

describe Qe::Qu do
  it "sets adapter when loading file" do
    Qe.adapter = nil
    load "qe/qu.rb"
    expect(Qe.adapter).to eql(Qe::Qu)
  end

  context "worker" do
    it "performs job" do
      expect(Qe::Worker)
        .to receive(:perform)
        .with(:a, :b, :c)

      Qe::Qu::Worker.perform(:a, :b, :c)
    end
  end

  context "enqueuing" do
    let(:worker) {
      double("worker", :queue => "some_queue", :name => "SomeWorker")
    }

    before do
      allow(Qu).to receive :enqueue
    end

    it "sets queue name" do
      Qe::Qu.enqueue(worker)
      expect(Qe::Qu::Worker.instance_variable_get("@queue")).to eql("some_queue")
    end

    it "enqueues job" do
      expect(::Qu)
        .to receive(:enqueue)
        .with(Qe::Qu::Worker, "SomeWorker", :a => 1)

      Qe::Qu.enqueue(worker, :a => 1)
    end
  end

  context "scheduling" do
    it "raises exception" do
      expect {
        Qe::Qu.schedule(double, Time.now, :a => 1)
      }.to raise_error(Qe::UnsupportedFeatureError)
    end
  end
end
