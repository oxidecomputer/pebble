// Copyright 2026 Oxide Computer Company. All rights reserved. Use
// of this source code is governed by a BSD-style license that can be found in
// the LICENSE file.

//go:build tools

package main

import (
	"fmt"

	_ "github.com/cockroachdb/crlfmt"
	_ "honnef.co/go/tools/cmd/staticcheck"
)

func main() {
	fmt.Println("Nothing to see here!")
}
