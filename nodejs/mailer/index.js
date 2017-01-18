var nodemailer = require('nodemailer');
var bunyan = require('bunyan');

var smtpConfig = {
    host: 'SMTP.SERVER.COM',
    port: 25,
    logger: bunyan.createLogger({name: 'nodemailer'})
};

var transporter = nodemailer.createTransport(smtpConfig);

// verify connection configuration
transporter.verify(function(error, success) {
   if (error) {
        console.log(error);
   } else {
        console.log('Server is ready to take our messages');
   }
});

// setup e-mail data with unicode symbols
var mailOptions = {
    from: 'raphael <sudokky.dev@gmail.com>', // sender address
    to: 'sudokky.dev@gmail.com', // list of receivers
    subject: '[TEST] Hello ✔', // Subject line
    text: 'Hello world ?' // plaintext body
};

transporter.sendMail(mailOptions, function(error, response){

	if (error){
		console.log(error);
	} else {
		console.log("Message sent : " + response.message);
	}
	transporter.close();
});

