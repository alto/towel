module VideoSupport
  def create_or_update_from_uploaded_data(params, options={})
    return true if (params.nil? || params[:uploaded_data].blank?)
    video= create(params.merge(options))
    unless audio.new_record?
      begin
        convert_in_background(audio)
      rescue BackgrounDRb::BdrbConnError
        # convert(audio)
      end
      return true
    end
    false
  end
  
  private
    def convert(audio)
      # puts "conversion started"
      audio_converted = audio.clone
      audio_converted.parent_id = audio.id
      audio_converted.content_type = 'audio/mpeg'
      audio_converted.filename = "#{audio.filename}.mp3"
      if audio_converted.save
        new_file = audio_converted.full_filename
        commmand = "lame --quiet --preset medium #{audio.full_filename} #{new_file}"
        # puts "commmand = #{commmand}"
        system(commmand)
      end
      # puts "conversion finished"
    end
    def convert_in_background(audio)
      MiddleMan.ask_work(:worker => :audio_worker, :worker_method => :convert, :data => audio.id)
    end
  
end
