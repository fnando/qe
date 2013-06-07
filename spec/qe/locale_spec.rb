require "spec_helper"

describe Qe::Locale do
  let(:i18n) { double("I18n", :locale => :en) }

  before do
    stub_const("I18n", i18n)
  end

  context "when including extension" do
    context "before Qe::Locale" do
      it "raises exception" do
        expect {
          mod = Module.new do
            include Qe::Locale
          end
        }.to raise_error(Qe::OutOfOrderError)
      end
    end

    context "after Qe::Locale" do
      it "does nothing" do
        expect {
          mod = Module.new do
            include Qe::Worker
            include Qe::Locale
          end
        }.not_to raise_error
      end
    end
  end

  context "when enqueuing" do
    before do
      Qe.adapter = Qe::Testing
    end

    it "sets locale" do
      expect {
        LocalizedWorker.enqueue
      }.to enqueue(LocalizedWorker).with(:locale => :en)
    end
  end

  context "when performing" do
    before do
      Qe.adapter = Qe::Immediate
    end

    it "sets locale" do
      i18n
        .should_receive(:locale=)
        .with(:en)

      LocalizedWorker.enqueue
    end
  end
end
