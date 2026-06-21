-- https://lua.expert/
local v1 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 210, 160)), ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 165, 95)) })

return {
	gold = {
		rodTitleText = "GOLD ROD",
		fishCollectedText = nil,
		showFillBar = true,
		fillChildName = "progress",
		labelGradient = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(196, 101, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(238, 169, 0)) }),
		fillBarBackground = Color3.fromRGB(255, 170, 0),
		fillBarStroke = Color3.fromRGB(255, 154, 0),
		listVerticalAlignment = Enum.VerticalAlignment.Center
	},
	silver = {
		rodTitleText = "SILVER ROD",
		fishCollectedText = nil,
		showFillBar = true,
		fillChildName = "fill",
		listVerticalAlignment = nil,
		labelGradient = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(101, 106, 134)), ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 233, 225)) }),
		fillBarBackground = Color3.fromRGB(212, 206, 202),
		fillBarStroke = Color3.fromRGB(64, 100, 152)
	},
	bronze = {
		rodTitleText = "BRONZE ROD",
		fishCollectedText = "CLAIM",
		showFillBar = false,
		fillChildName = "progress",
		labelGradient = v1,
		fillBarBackground = Color3.fromRGB(255, 190, 130),
		fillBarStroke = Color3.fromRGB(230, 150, 90),
		listVerticalAlignment = Enum.VerticalAlignment.Center
	}
}