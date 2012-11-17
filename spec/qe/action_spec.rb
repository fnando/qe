require "spec_helper"

describe Qe::Action do
  NotificationWorker = Class.new do
    include Qe::Worker
    include Qe::Action

    def shutdown; end
    def default; end
  end

  let(:job) { NotificationWorker.new({}) }

  it "responds to perform" do
    expect(job).to respond_to(:perform)
  end

  it "performs specified action" do
    job.should_receive(:hello)
    job.options[:action] = :hello

    job.perform
  end

  it "executes default action when have no action" do
    job.should_receive(:default)
    job.perform
  end

  it "raises exception when action method doesn't exist" do
    job.options[:action] = :invalid

    expect {
      job.perform
    }.to raise_error(Qe::Action::MissingActionError, "the action :invalid is not defined")
  end
end
