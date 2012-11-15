class LoginViewController < UIViewController
	attr_accessor :handle_text

	def signIn(sender)
		$gcc = GlobalChatController.new(self.handle_text.text)
		self.performSegueWithIdentifier("Welcome", sender:self)
	end
end
