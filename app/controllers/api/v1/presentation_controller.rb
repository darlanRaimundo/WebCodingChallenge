module Api
	module V1
		class PresentationController < ApplicationController
      			
			def index
				@presentation = Presentation.new(presentation_params)

				caminho = "/home/darlan/Downloads/proposals.txt"
				arrPresentations = []
				arrPresentationsAux = []
				arrTimePresentation = []
				arrTimePresentationAux = []
				lines = ""
				titlePresentation = ""
				timePresentation = ""				
				counter = 0

				File.open(caminho, 'r') do |f1|
				  while line = f1.gets
					for i in 0..line.length do
						if 
							line[i] == "0" or 
							line[i] == "1" or
							line[i] == "2" or
							line[i] == "3" or
							line[i] == "4" or
							line[i] == "5" or 
							line[i] == "6" or
							line[i] == "7" or
							line[i] == "8" or
							line[i] == "9"
							break
						else
							titlePresentation += line[i].to_s
						end
					end

					for i in 0..line.length do
						if 
							line[i] == "0" or 
							line[i] == "1" or
							line[i] == "2" or
							line[i] == "3" or
							line[i] == "4" or
							line[i] == "5" or 
							line[i] == "6" or
							line[i] == "7" or
							line[i] == "8" or
							line[i] == "9"
							timePresentation += line[i]
							
						end
					end
					
					arrPresentations[counter] = {"title":titlePresentation,"time":timePresentation}

					if timePresentation == ""
						arrTimePresentation[counter] = "05"
					else
						arrTimePresentation[counter] = timePresentation
					end
					
					titlePresentation = "" 
					timePresentation = ""
					counter += 1
				  end
				end

				#finalJSON = {"lista": arrPresentations}
				totalTimeMorningSession = 0
				totalTimeAfternoonEvent = 0
				totalTimeNetworkingEvent = 0
				tracks = {}
				morningSession = {}
				afternoonSession = {}
				networkingEvent = {}

				arrPresentations.each do |x|
					arrPresentationsAux.push(x)
				end

				arrTimePresentation.each do |x|
					arrTimePresentationAux.push(x)
				end

				counter = 0
				counter2 = 0
				counter3 = 0
				for i in 0..arrPresentations.length do
					if totalTimeMorningSession < 180 and arrPresentationsAux[i] != ""
						totalTimeMorningSession += arrTimePresentationAux[i].to_i
						arrTimePresentationAux[i] = "0"
						arrPresentationsAux[i] = ""
						morningSession[counter+1] = arrPresentations[i]
						counter += 1
					end

					if (totalTimeNetworkingEvent < 60 and 
						arrPresentationsAux[i] != "" and 
						totalTimeNetworkingEvent + arrTimePresentationAux[i].to_i <= 60 and 
						arrTimePresentation[i] != "45" and	
						arrTimePresentation[i] != "05")

						totalTimeNetworkingEvent += arrTimePresentationAux[i].to_i
						arrTimePresentationAux[i] = "0"
						arrPresentationsAux[i] = ""
						networkingEvent[counter2+1] = arrPresentations[i]
						counter2 += 1
					end

					if (totalTimeAfternoonEvent < 180 and 
						arrPresentationsAux[i] != "" and
						totalTimeAfternoonEvent + arrTimePresentationAux[i].to_i <= 180)

						totalTimeAfternoonEvent += arrTimePresentationAux[i].to_i
						arrTimePresentationAux[i] = "0"
						arrPresentationsAux[i] = ""
						afternoonSession[counter3+1] = arrPresentations[i]
						counter3 += 1
					end
					
				end

				tracks = {"track":{"morning":morningSession,"afternoonSession":afternoonSession,"networkingEvent":networkingEvent}}

				render json:tracks
			end


			private
			def presentation_params
				params.permit(:title, :time)
			end
      
		end
	end
end
