class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = ["Bananas", "Chocolate Milk", "Pencils"]

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      if @@cart.empty?
        resp.write "Your cart is empty"
      else
        @@cart.each do |item|
          resp.write "#{item}\n"
        end
      end
    elsif req.path.match(/add/)
      # Sets item to the requested item
      item = req.params["item"]
      # Checks to see if passed in item exists in the @@items array
      if @@items.include?(item)
        @@cart << item # Pushes item into the @@cart array
        resp.write "added #{item}" # Returns with a message saying the item was added to the cart
      else
        resp.write "We don't have that item"
      end
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
