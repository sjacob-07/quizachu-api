# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

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


25.times.each do |i|
    User.create({
        fullname: Faker::Name.name,
        email: Faker::Internet.email,
        external_uid: Faker::Alphanumeric.unique.alpha(number: 10),
        profile_picture_url: images.sample        
    })
end; 0

20.times.each do |i|
    Assessment.create(
        title: Faker::Hobby.activity,
        description: Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 2),
        image_url: images.sample,
        context: Faker::Lorem.paragraphs.join(","),
        passmark: rand(75..100),
        status: ["DRAFT", "PUBLISHED"].sample,
        ques_count: rand(1..10),
        is_active: true,
        created_by_id: User.all.sample.id,
    )
end; 0