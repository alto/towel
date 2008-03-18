class AudioWorker < BackgrounDRb::MetaWorker
  set_worker_name :audio_worker

  def convert(id)
    @logger.info('Audio conversion started')
    audio = Song.find(id)
    audio_converted = audio.clone
    audio_converted.parent_id = audio.id
    audio_converted.content_type = 'audio/mpeg'
    audio_converted.filename = "#{audio.filename}.mp3"
    if audio_converted.save
      new_file = audio_converted.full_filename
      command = "lame --quiet --preset medium #{audio.full_filename} #{new_file}"
      # puts "commmand = #{commmand}"
      system(command)
    end
    @logger.info('Audio conversion finished')
  end
  
end

