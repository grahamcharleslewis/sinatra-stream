require "bunny"
require "json"

# Run docker image...
# docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3.12-management
# http://localhost:15672


connection = Bunny.new
connection.start

channel = connection.create_channel
channel.confirm_select

queue  = channel.queue("orders")
queue.subscribe(manual_ack: true) do |delivery_info, metadata, payload|
  puts payload
  channel.ack(delivery_info.delivery_tag)
end

order = { item: "ABC", qty: 2, price: 10.50 }.to_json
queue.publish(order)
channel.wait_for_confirms

sleep 1

channel.close
connection.close