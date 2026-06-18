ps.sub("ind-app-title", function(args)
	args.value = "Yazi: " .. tostring(cx.active.current.cwd)
	return args
end)
