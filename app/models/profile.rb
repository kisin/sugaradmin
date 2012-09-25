# encoding: UTF-8

class Profile < ActiveRecord::Base
	belongs_to :user, :touch => true
	belongs_to :annualincome
	belongs_to :bodytype
	belongs_to :budget
	belongs_to :city
	belongs_to :drinkhabbit
	belongs_to :education
	belongs_to :eyecolor
	belongs_to :region
	belongs_to :smokehabbit
	belongs_to :haircolor
	belongs_to :height
	belongs_to :familystatus

	attr_protected :user_id 



	#presenters
	def displayname
		self.update_attributes(:nickname => user.email[/[^@]+/]) if nickname.nil?
		nickname
	end

	def age
		return "לא הוזן גיל" if yearofbirth.blank?
		prefix = (user.male?) ? "בן" : "בת"
		"#{prefix} #{Time.now.year - yearofbirth}" 
	end

	def headline
		return "לא הוזנה שורת פתיחה" if heading.blank?
		heading
	end

	def location
		output = "לא הוזן מיקום"
		output = region.title unless region.blank?
		unless city.blank?
			output = (region.blank?) ? city.title : "#{output}, #{city.title}"
		end

		output
	end

	def gender
		user.gender
	end

	def arrangement_text
		return "לא הוזן" if arrangement.blank?
		arrangement
	end

	def description_text
		return "לא הוזן" if description.blank?
		description
	end

	def education_text
		return "לא הוזן" if education.blank?
		education.title
	end

	def height_text
		return "לא הוזן" if height.blank?
		height.title
	end

	def bodytype_text
		return "לא הוזן" unless bodytype.present?
		bodytype.title
	end

	def eyecolor_text
		return "לא הוזן" unless eyecolor.present?
		eyecolor.title
	end

	def haircolor_text
		return "לא הוזן" unless haircolor.present?
		haircolor.title
	end

	def budget_text
		return "לא הוזן" unless budget.present?
		budget.title
	end

	def occupation_text
		return "לא הוזן" unless occupation.present?
		occupation
	end

	def annualincome_text
		return "לא הוזI" unless annualincome.present?
		annualincome.title
	end

	def smokehabbit_text
		return "לא הוזן" unless smokehabbit.present?
		smokehabbit.title
	end

	def drinkhabbit_text
		return "לא הוזן" unless drinkhabbit.present?
		drinkhabbit.title
	end

	def familystatus_text
		return "לא הוזן" unless familystatus.present?
		familystatus.title
	end


end
