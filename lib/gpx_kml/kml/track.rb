module KML
  # Docu
  class Track
    def initialize(track)
      return unless track.is_a?(Nokogiri::XML::Element) && !track.xpath('self::xmlns:LineString').empty?

      @node = track
      @name = _name
      @points = _points
      @author = _author
      @link = _link
    end

    attr_reader :name, :points, :author, :link

    private

    def _name
      elem = @node.xpath('.')
      while elem.xpath('self::xmlns:kml').empty?
        elem = elem.xpath('..')
        return elem.xpath('./xmlns:name/text()').to_s unless elem.xpath('./xmlns:name').empty?
      end
      ''
    end

    def _points
      p = []
      points = @node.xpath('./xmlns:coordinates/text()').to_s
      array_points = points.split(' ')
      array_points.each_with_index do |ap, i|
        p[i] = KML::Point.new ap, self, @node
      end
      p
    end

    def _author
      elem = @node.xpath('.')
      while elem.xpath('self::xmlns:kml').empty?
        elem = elem.xpath('..')
        return elem.xpath('./atom:author/atom:name/text()').to_s unless elem.xpath('./atom:author').empty?
      end
      ''
    end

    def _link
      elem = @node.xpath('.')
      while elem.xpath('self::xmlns:kml').empty?
        elem = elem.xpath('..')
        return elem.xpath('./atom:link/@href').to_s unless elem.xpath('./atom:link').empty?
      end
      ''
    end
  end
end
