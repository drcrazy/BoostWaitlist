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
    initialReply = L["initialReply"],
    doneMessage = L["whisperDone"],
    inactivereplymsg = L["whisperInactive"],
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
