require "spec_helper"

describe Qe::Testing do
  let(:job) { double("job").as_null_object }

  it "stores enqueued job" do
    Qe::Testing.enqueue(HelloWorker, a: 1)
    job = Qe.jobs.first

    expect(job).to include(worker: HelloWorker)
    expect(job).to include(options: {a: 1})
  end

  it "schedules job" do
    date = Time.now
    Qe::Testing.schedule(HelloWorker, date, a: 1)
    job = Qe.jobs.first

    expect(job).to include(run_at: date)
  end

  it "runs jobs" do
    Qe::Testing.enqueue(HelloWorker, a: 1)

    instance = double.as_null_object
    instance.should_receive(:perform)

    HelloWorker
      .should_receive(:new)
      .with(a: 1)
      .and_return(instance)

    Qe.drain
  end
end
