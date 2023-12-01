# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "csv"

#CREATE USERS
images = ["https://rxpspark.b-cdn.net/setup/security_images/fp_001.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_002.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_003.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_004.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_005.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_006.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_007.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_008.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_009.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_010.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_011.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_012.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_013.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_014.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_015.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_016.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_017.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_018.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_019.jpg",
    "https://rxpspark.b-cdn.net/setup/security_images/fp_020.jpg"]

RoleMaster.create(name: "Admin", description: "Can do everything")
RoleMaster.create(name: "Participant", description: "Can only answer assessments")

25.times.each do |i|
    user = User.create!({
        fullname: Faker::Name.name,
        email: Faker::Internet.email,
        external_uid: Faker::Alphanumeric.unique.alpha(number: 10),
        profile_picture_url: images.sample        
    })

    role = RoleMaster.all.sample
    UserRole.create(user_id: user.id, role_master_id: role.id)
end; 0

ques_filepath = "/Users/susannajacob/code/sjacob-07/quizachu_internal/ques_quizachu.csv"
File.file?(ques_filepath)
csv_array = CSV.read(ques_filepath); 0

6.times.each do |i|
    assessment = Assessment.create(
        title: "General Knowledge #{i+1}",
        description: "General Knowledge #{i+1}",
        image_url: images.sample,
        passmark: rand(75..100),
        status: ["PUBLISHED"].sample,
        ques_count: rand(1..10),
        is_active: true,
        created_by_id: User.all.sample.id,
    )


    csv_array.sample(assessment.ques_count).each_with_index do |ques, count|
        aq = AssessmentQuestion.create(
            assessment_id: assessment.id,
            question: ques[0],
            question_type: ques[1],
            question_description: ques[2],
            order_seq: count + 1,
        )

        if ques[3].present?
            AssessmentOption.create(
                assessment_id: assessment.id,
                assessment_question_id: aq.id,
                option: ques[3],
                order_seq: 1,
                is_correct_option: ques[4],
                option_type: "TEXT"
            )
        end
        if ques[5].present?
            AssessmentOption.create(
                assessment_id: assessment.id,
                assessment_question_id: aq.id,
                option: ques[5],
                order_seq: 2,
                is_correct_option: ques[6],
                option_type: "TEXT"
            )
        end
        if ques[7].present?
            AssessmentOption.create(
                assessment_id: assessment.id,
                assessment_question_id: aq.id,
                option: ques[7],
                order_seq: 3,
                is_correct_option: ques[8],
                option_type: "TEXT"
            )
        end
    end
end; 0

# [
#     {question: "What is the colour of the sky?",question_type: "MCQ", question_description: "Look up", options: [{option: "Blue", is_correct_option: true, order_seq: 1}, {option: "Red", is_correct_option: false, order_seq: 1}, option: "Black", is_correct_option: false, order_seq: 1]},

#     {question: "Which of the following operations have 4 as the answer?",question_type: "MRQ", question_description: "Do each of the calculations to find out.", options: [{option: "4 + 0", is_correct_option: true, order_seq: 1}, {option: "3 + 1", is_correct_option: true, order_seq: 2}, option: "4 + 4", is_correct_option: false, order_seq: 3]},

#     {question: "In which year did India gain their independence?",question_type: "SHORT_ANSWER", question_description: "Look into your history books?", options: [{option: "1947", is_correct_option: true, order_seq: 1}},

#     {question: "Give me some information about the Venchi ice-cream branch?",question_type: "LONG_ANSWER", question_description: "Wikipedia should have some answers for you", options: [{option: "Venchi is an Italian gourmet chocolate manufacturer founded by chocolatier Silviano Venchi. After its establishment in Turin in early 1878, the company expanded throughout Italy with its Nougatine, small candies made of crushed and caramelized hazelnuts coated in dark chocolate.", is_correct_option: true, order_seq: 1}},
# ]
