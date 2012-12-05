require "./workers"

loop do
  MailerWorker.enqueue(:name => "John Doe", :email => "john@example.org")
  ClockWorker.enqueue
  LaterWorker.enqueue :run_at => Time.now + 5, :time => Time.now

  sleep 3
end

