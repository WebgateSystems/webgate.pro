# frozen_string_literal: true

class AppIdService
  class << self
    def version
      @version ||= check_hash
    end

    private

    def check_hash
      revision_file = Rails.root.join('REVISION')
      if File.exist?(revision_file)
        File.read(revision_file).first(8)
      else
        `git rev-parse --short HEAD`.chomp
      end
    end
  end
end
