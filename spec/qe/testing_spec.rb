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
end
