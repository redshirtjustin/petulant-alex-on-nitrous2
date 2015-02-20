order = [30, 33, 19, 144, 68, 20]
pstack = [33, 30, 144, 68, 19, 1]

pstack.each do |bb|
    if order.include?(bb)
        puts bb
    elsif order.include?(bb)
        puts "Broken. Not included."
        break
    end
end
