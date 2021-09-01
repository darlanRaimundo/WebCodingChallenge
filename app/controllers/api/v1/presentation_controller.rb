module Api
	module V1
		class PresentationController < ApplicationController
      			
			def index
				#@presentation = Presentation.new(presentation_params)

				path =  params[:path]				
				arrPresentations = []
				arrPresentationsAux = []
				arrTitlePresentation = []
				arrTimePresentation = []
				arrTimePresentationAux = []
				lines = ""
				titlePresentation = ""
				timePresentation = ""				
				counter = 0

				File.open(path, 'r') do |f1|
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
					arrTitlePresentation[counter] = titlePresentation

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

				trackCounter = 0
				loopContinue = false
				arrAux=[]
				begin
					counter = 0
					counter2 = 0
					counter3 = 0
					totalTimeMorningSession = 0
					totalTimeAfternoonEvent = 0
					totalTimeNetworkingEvent = 0
					
					i = 0
					for i in 0..arrPresentations.length-1 do
						if (totalTimeMorningSession < 180 and 
							arrPresentationsAux[i] != "" and
							totalTimeMorningSession + arrTimePresentationAux[i].to_i <= 180)

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
							if (arrTimePresentation[i].to_s == "05")
								timeValuePresentation = "05"
							else
								timeValuePresentation = arrTimePresentation[i]
							end
							afternoonSession[counter3+1] = {"title":arrTitlePresentation[i],"time":timeValuePresentation}
							counter3 += 1
						end
					end
					
					tracks[trackCounter] = {"track":{"morning":morningSession,"afternoonSession":afternoonSession,"networkingEvent":networkingEvent}}
					
					arrAux.clear
					for z in 0..arrPresentationsAux.length-1 do
						if arrPresentationsAux[z] != ""
							arrAux.push(arrPresentationsAux[z])
						end
					end
					trackCounter += 1

					morningSession = {}
					afternoonSession = {}
					networkingEvent = {}

				end while arrAux.length > 0	

				render json:tracks
			end


			private
			def presentation_params
				params.permit(:path)
			end
      
		end
	end
end
