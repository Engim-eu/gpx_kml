# frozen_string_literal:true

module CONVERTER
  # Docu
  class Converter
    def self.gpx_to_kml(gpx_path, output_path)
      return unless File.directory?(output_path)

      output_path = output_path[0..-2] if output_path[-1].eql?('/')
      gpx = GPXKML::Gpx.new(gpx_path)
      return nil if gpx.nil? || !gpx.valid?

      kml = Nokogiri::XML::Builder.new do |xml|
        xml.kml('xmlns': 'http://www.opengis.net/kml/2.2', 'xmlns:gx': 'http://www.google.com/kml/ext/2.2',
                'xmlns:atom': 'http://www.w3.org/Atom') do
          xml.Document do
            if gpx.name.nil? || gpx.name.empty?
              xml.name(gpx.file_name[0..-5])
            else
              xml.name(gpx.name)
            end
            xml.visibility('1')
            xml.open('0')
            unless gpx.author.nil? || gpx.author.empty?
              xml['atom'].author do
                xml['atom'].name(gpx.author)
              end
            end
            xml['atom'].link(href: gpx.link) unless gpx.link.nil? || gpx.link.empty?
            kml_points(xml, gpx)
            kml_routes(xml, gpx)
            kml_tracks(xml, gpx)
          end
        end
      end
      name = "#{output_path}/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{gpx.file_name[0..-5]}.kml"
      f = File.open("#{output_path}/#{name}", 'w')
      f.write(kml.to_xml)
      f.close
      name
    end

    def self.kml_to_gpx(kml_path, output_path)
      return unless File.directory?(output_path)

      output_path = output_path[0..-2] if output_path[-1].eql?('/')
      kml = GPXKML::Kml.new(kml_path)
      return nil if kml.nil? || !kml.valid?

      gpx = Nokogiri::XML::Builder.new do |xml|
        xml.gpx('version': '1.1', 'creator': 'https://www.github.com/engim-eu/gpx_kml',
                'xmlns': 'https://www.topografix.com/GPX/1/1', 'xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance') do
          xml.metadata do
            xml.name(kml.file_name[0..-5])
          end
          gpx_points(xml, kml)
          gpx_routes(xml, kml)
          gpx_tracks(xml, kml)
        end
      end
      name = "#{output_path}/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{kml.file_name[0..-5]}.gpx"
      f = File.open("#{output_path}/#{name}", 'w')
      f.write(gpx.to_xml)
      f.close
      name
    end

    private

    def self.kml_routes(xml, gpx)
      if gpx.routes?
        gpx.routes.each do |r|
          xml.LinearRing do
            xml.extrude('0')
            xml.tassellate('0')
            xml.altitudeMode('clampToGroud')
            s = ''
            r.points.each do |p|
              s = if p.elevation.nil? || p.elevation.empty?
                    s + "#{p.latitude},#{p.longitude} "
                  else
                    s + "#{p.latitude},#{p.longitude},#{p.elevation} "
                  end
            end
            xml.coordinates(s[0..-2])
          end
        end
      end
    end

    def self.kml_tracks(xml, gpx)
      if gpx.tracks?
        gpx.tracks.each do |t|
          xml.LineString do
            xml.extrude('0')
            xml.tassellate('0')
            xml.altitudeMode('clampToGroud')
            s = ''
            points = []
            t.segments.each do |sg|
              sg.points.each do |p|
                points = points << p
              end
            end
            points.each do |p|
              next if p.nil?

              s = if p.elevation.nil? || p.elevation.empty?
                    s + "#{p.latitude},#{p.longitude} "
                  else
                    s + "#{p.latitude},#{p.longitude},#{p.elevation} "
                  end
            end
            xml.coordinates(s[0..-2])
          end
        end
      end
    end

    def self.kml_points(xml, gpx)
      if gpx.points?
        gpx.points.each do |p|
          xml.Point do
            xml.extrude('0')
            xml.altitudeMode('clampToGroud')
            if p.elevation.nil? || p.elevation.empty?
              xml.coordinates("#{p.latitude},#{p.longitude}")
            else
              xml.coordinates("#{p.latitude},#{p.longitude},#{p.elevation}")
            end
          end
        end
      end
    end

    def self.gpx_points(xml, kml)
      if kml.points?
        kml.points.each do |p|
          next if p.nil?

          xml.wpt('lat': "#{p.latitude}", 'lon': "#{p.longitude}") do
            xml.ele("#{p.elevation}") unless p.elevation.nil? || p.elevation.empty?
            xml.name(p.name) unless p.name.nil? || p.name.empty?
            xml.desc("author = #{p.author}") unless p.author.nil? || p.author.empty?
            xml.link('href': p.link) unless p.link.nil? || p.link.empty?
          end
        end
      end
    end

    def self.gpx_routes(xml, kml)
      if kml.routes?
        kml.routes.each do |r|
          next if r.nil?

          xml.rte do
            xml.name(r.name) unless r.name.nil? || r.name.empty?
            xml.desc("author= #{r.author}") unless r.author.nil? || r.author.empty?
            xml.link('href': r.link) unless r.link.nil? || r.link.empty?
            r.points.each do |p|
              next if p.nil?

              xml.rtept('lat': "#{p.latitude}", 'lon': "#{p.longitude}") do
                xml.ele("#{p.elevation}") unless p.elevation.nil? || p.elevation.empty?
                xml.desc("author = #{p.author}") unless p.author.nil? || p.author.empty?
                xml.link('href': p.link) unless p.link.nil? || p.link.empty?
              end
            end
          end
        end
      end
    end

    def self.gpx_tracks(xml, kml)
      if kml.tracks?
        kml.tracks.each do |t|
          next if t.nil?

          xml.trk do
            xml.name(t.name) unless t.name.nil? || t.name.empty?
            xml.desc("author= #{t.author}") unless t.author.nil? || t.author.empty?
            xml.link('href': t.link) unless t.link.nil? || t.link.empty?
            xml.trkseg do
              t.points.each do |p|
                next if p.nil?

                xml.trkpt('lat': "#{p.latitude}", 'lon': "#{p.longitude}") do
                  xml.ele("#{p.elevation}") unless p.elevation.nil? || p.elevation.empty?
                  xml.desc("author = #{p.author}") unless p.author.nil? || p.author.empty?
                  xml.link('href': p.link) unless p.link.nil? || p.link.empty?
                end
              end
            end
          end
        end
      end
    end
  end
end
