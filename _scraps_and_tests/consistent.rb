class Consistent 
    def consistent?(kat)
        first = kat.first
        last = kat.last
        len = kat.size
        
        (last - first) == (len - 1) ? true : false
    end
    
    def make_consistent(start=1) 
        if (self.is_pstack_consistent?) && (self.positions.first.position == start)
            # no need to work, the pstack is already consistent, and we're not going to shift it
            return true
        elsif (self.is_pstack_consistent?) && (start > 1)
            # just need to shift the pstack, cuz it's consistent
            self.shift(start)
        elsif (!self.is_pstack_consistent?) && (start > 0)
            self.positions.order(position: :asc).each do |p|
                # b/c each story.positions.position needs to be uniqe, we run into the issue of 
                # Validation failed: Position has already been taken
                # so, we'll set the order in negative numbers and just flip their signs
                p.position = -(start)
                p.save!
                start += 1
            end
            # now to switch back to positive positions
            self.positions.each do |p|
                p.position = (p.position).abs 
                p.save!
            end
            return true
        elsif start <= 0
            return false
        end
    end

    def butter
        puts "knife" 
    end
end