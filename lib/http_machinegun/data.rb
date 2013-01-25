# coding: utf-8

module HttpMachinegun
  class Data

    attr_accessor :data

    def initialize(_data)
      self.data =  if file = Pathname.new(_data).exist?
                file.open.read
              else
                _data
              end
    end

    def to_s
      self.data
    end

  end
end
