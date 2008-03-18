require 'erb'
require 'yaml'
require 'net/pop'

class MmsWorker < BackgrounDRb::MetaWorker
  set_worker_name :mms_worker
  
  def import(config)
    @logger.info('MMS contribution import started')
    begin
      Net::POP3.start(config[:server], config[:port], config[:user], config[:password]) do |pop|
        pop.each_mail do |mail|
          begin
            content = mail.pop
            mms = MMS2R::Media.new(TMail::Mail.parse(content))
            contributions = Contribution.import_mms(mms)
            if contributions.include?(nil)
              handle_error('MMS contribution import error', content)
            else
              @logger.info("MMS contribution import created contributions #{contributions.collect {|c| c.id}.inspect}")
            end
          rescue TMail::SyntaxError => e
            handle_error("MMS contribution import parsing error #{e}", content)
          rescue ActiveRecord::RecordNotFound => e
            handle_error("MMS contribution import data error #{e}", content)
          end
          mail.delete
        end
      end
    rescue => e
      @logger.error("MMS contribution import unknown error #{e}")
    end
    @logger.info('MMS contribution import finished')
  end
  
  def handle_error(message, mail_content)
    SystemMailer.deliver_mms_import_error(message, mail_content)
    @logger.error(message)
  end
  
end
