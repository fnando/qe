class LocalizedWorker
  include Qe::Worker
  include Qe::Locale
  def perform; end
end
