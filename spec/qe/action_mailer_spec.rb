require "spec_helper"

describe Qe::ActionMailer do
  let(:worker) {
    Class.new do
      include Qe::Worker
      include Qe::ActionMailer
    end
  }

  let(:mailer) { double(:mailer) }

  subject(:job) {
    worker.new(
      :name => "John Doe",
      :email => "john@example.org",
      :mail => :hello
    )
  }

  describe "#mail" do
    it "raises error when have no :mail" do
      job.options.delete(:mail)

      expect {
        job.mail
      }.to raise_error(Qe::ActionMailer::MissingMailNameError)
    end

    it "returns object for :mail option" do
      job.stub :mailer => mailer

      mailer
        .should_receive(:hello)
        .with(job.options)

      job.mail
    end
  end

  describe "#mailer" do
    it "raises error when method implemented" do
      expect {
        job.mailer
      }.to raise_error(Qe::ActionMailer::AbstractMethodError)
    end
  end

  describe "#perform" do
    it "delivers e-mail" do
      mail = double(:mail)
      job.stub :mail => mail

      mail.should_receive(:deliver)

      job.perform
    end
  end
end
