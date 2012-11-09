require "./workers"

loop do
  puts "=> Enqueuing jobs [#{Time.now}]"

  MailerWorker.enqueue(:name => "John Doe", :email => "john@example.org")
  ClockWorker.enqueue

  sleep 3
end

