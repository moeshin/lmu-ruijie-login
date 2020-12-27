package main

import "os/exec"

func ping(ip string) bool {
	cmd := exec.Command("ping", "-n", "1", "-w", "1000", ip)
	err := cmd.Run()
	return err == nil
}
