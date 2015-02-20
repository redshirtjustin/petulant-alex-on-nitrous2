
class Consistent 
    def consistent?(kat)
        first = kat.first
        last = kat.last
        len = kat.size
        
        (last - first) == (len - 1) ? true : false
    end
end

RSpec.describe Consistent do
    it "/ fails the consistent?" do 
        g = [1,2,3,4,5,7]
        peach = Consistent.new()
        expect(peach.consistent?(g)).to be false
    end
    
    it "/ fails the consistent?, array shuffled" do
        g = [1,2,3,4,5,45]
        g.shuffle
        peach = Consistent.new()
        expect(peach.consistent?(g)).to be false
    end
    
    it "/ succeeds the consistent?, array in sequence" do 
        g = [1,2,3,4,5,6]
        peach = Consistent.new()
        expect(peach.consistent?(g)).to be true
    end
    
    it "/ succeeds the consistent?, array shuffled" do
        g = [1,2,3,4,5,6]
        g.shuffle
        peach = Consistent.new()
        expect(peach.consistent?(g)).to be true
    end
    
    it "/ succeeds the consistent?, 150 length array" do
        g = []
        for i in 1..150
            g << i
        end
        peach = Consistent.new()
        expect(peach.consistent?(g)).to be true
    end
    
    it "/ succeeds the consistent?, array starting at 11 length 6" do
        g = [11,12,13,14,15,16]
        peach = Consistent.new()
        expect(peach.consistent?(g)).to be true
    end
    
    
    it "/ succeeds the consistent?, array starting at 150" do
       g = []
        for i in 150..1500
            g << i
        end
        peach = Consistent.new()
        expect(peach.consistent?(g)).to be true 
    end
    
    
end