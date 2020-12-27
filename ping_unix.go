//+build aix darwin dragonfly freebsd js,wasm linux netbsd openbsd solaris

package main

import "os/exec"

func ping(ip string) bool {
	cmd := exec.Command("ping", "-c", "1", "-W", "2", ip)
	err := cmd.Run()
	return err == nil
}
