# coding: utf-8

module HttpMachinegun
  class Data

    attr_accessor :data

    def initialize(_data)
      file = Pathname.new(_data)
      self.data =  if file.exist?
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
