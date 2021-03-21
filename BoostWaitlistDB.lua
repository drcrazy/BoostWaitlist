------------------------------------
-- BoostWaitlist Beta (3/11/2020)
------------------------------------

_G.BoostWaitlistDBDefaults = {
  Main = {
    version = '3.0.0',
    active = false,
    forming = false,
    enableSounds = false,
    inactivereply = false,
    enableBalanceWhisperThreshold = false,
    enableWaitlist = true,
    enableStats = true,
    everActive = true,
    autobill = true,
    waitlistInfo = {
      waitlist = {},
      requestsByTarget = {},
      requestsBySender = {},
    },
    blacklist = {},
    accountBalance = {},
    overrideCharge = {},
    initialReply = "Thanks for your interest in my boosts.",
    doneMessage = "Hey, I'm done boosting for now. Sorry you didn't get a chance to join - I'll try to get you in next time!",
    inactivereplymsg = "Thanks for your interest in my boosts, however, I'm currently inactive.",
    name = "Booster",
    cost = 15,
    maxWaitlist = 20,
    balanceWhisperThreshold = 0,
  },
  GUI = {
    points = {"CENTER"},
    minimap = {
      hide = false,
    },
  },
  Options = {
    points = {"CENTER"},
  }
}

