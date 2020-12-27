package main

import (
	"encoding/json"
	"fmt"
	"github.com/xiaoqidun/goini"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"
	"path"
	"regexp"
	"strings"
	"time"
)

type Result struct {
	Result  string `json:"result"`
	Message string `json:"message"`
}

var _VERSION_ = "unknown"

func main() {
	shouldPing := false

	if len(os.Args) > 1 {
		arg1 := os.Args[1]
		switch arg1 {
		case "ping":
			shouldPing = true
		case "-v", "--version":
			fmt.Println(_VERSION_)
			return
		default:
			fmt.Print(`Usage:
  login				登录校园网
  login ping 		在登录前进行 ping
  login <options>

Options:
  -v, --version		打印版本
  -h, --help		打印帮助
`)
			return
		}
	}

	dir, _ := os.Getwd()
	ini := goini.NewGoINI()
	file := path.Join(dir, "config.ini")
	stat, err := os.Stat(file)
	if err != nil || stat.IsDir() {
		fmt.Println("文件不存在")
		return
	}
	if err := ini.LoadFile(file); err != nil {
		fmt.Println("解析配置文件时出错")
		fmt.Println(err)
		return
	}
	user := ini.GetString("", "user", "")
	pass := ini.GetString("", "pass", "")
	ip := ini.GetString("", "ip", "192.168.15.22")
	if "" == user {
		fmt.Println("配置缺少 user")
	}
	if "" == pass {
		fmt.Println("配置缺少 pass")
	}

	if shouldPing {
		for !ping(ip) {
			time.Sleep(1 * time.Second)
			fmt.Printf("ping %s\n", ip)
		}
	}

	r, msg := login(user, pass, ip)
	fmt.Println(getResultString(r))
	if "" != msg {
		fmt.Println(msg)
	}
}

func getResultString(r int) string {
	switch r {
	case 0:
		return "登录成功"
	case 1:
		return "登录失败"
	case 2:
		return "请检测是否连接校园网"
	case 3:
		return "已登录"
	case 4:
		return "JSON 解析错误"
	}
	return ""
}

//goland:noinspection GoUnhandledErrorResult
func login(user, pass, ip string) (r int, msg string) {
	client := &http.Client{
		Timeout: 5 * time.Second,
		CheckRedirect: func(req *http.Request, via []*http.Request) error {
			return http.ErrUseLastResponse
		},
	}

	resp, err := client.Head("http://" + ip + "/eportal/redirectortosuccess.jsp")
	if err != nil {
		return 2, ""
	}
	defer resp.Body.Close()
	location := resp.Header.Get("Location")
	match, _ := regexp.MatchString("http://"+strings.ReplaceAll(ip, ".", "\\.")+"/eportal/(\\./)?success\\.jsp", location)
	if match {
		return 3, ""
	}

	resp, err = client.Get(location)
	if err != nil {
		return 2, ""
	}
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	reg := regexp.MustCompile("<script>(?:top\\.)?(?:self\\.)?location.href=[\"'](.*)[\"']</script>")
	href := reg.FindStringSubmatch(string(body))
	URL, _ := url.Parse(href[1])

	v := url.Values{}
	v.Add("userId", user)
	v.Add("password", pass)
	v.Add("queryString", URL.RawQuery)
	v.Add("service", "")
	v.Add("operatorUserId", "")
	v.Add("passwordEncrypt", "")

	resp, err = http.PostForm("http://"+ip+"/eportal/InterFace.do?method=login", v)
	if err != nil {
		return 2, ""
	}
	defer resp.Body.Close()

	body, _ = ioutil.ReadAll(resp.Body)
	var mJson Result
	err = json.Unmarshal(body, &mJson)
	if err != nil {
		return 4, string(body)
	}
	if mJson.Result == "success" {
		r = 0
	} else {
		r = 1
	}
	return r, mJson.Message
}