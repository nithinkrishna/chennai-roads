module ChennaiRoads
  class Application
		def call(env)

			begin
				klass, act = get_controller_and_action(env)
				controller = klass.new(env)
				text = controller.send(act)

				[200, {'Content-Type' => 'text/html'}, [ text ]]
			rescue Exception => e
				Logger.new(e).log
			end

		end


		def get_controller_and_action(env)
			_, cont, action, after = env["PATH_INFO"].split('/', 4)

			return [HomeController, :index] if _ == "/"

			cont = cont.capitalize
			cont += "Controller"

			[Object.const_get(cont), action]
		end
	end


	class Controller
		def initialize(env)
			@env = env
		end
		
		def env
			@env
		end
	end

	class Logger
		def initialize(exception, log_file='debug.txt')
			@e = exception
			@log_file = log_file
		end

		def log
			open(@log_file, 'a') { |f| 
				f << @e.message 
				f << @e.backtrace.join("\n")
				3.times { f << "\n" }
			}
		end
	end

end
