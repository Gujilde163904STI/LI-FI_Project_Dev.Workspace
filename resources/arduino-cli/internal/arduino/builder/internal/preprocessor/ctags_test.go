// This file is part of arduino-cli.
//
// Copyright 2025 ARDUINO SA (http://www.arduino.cc/)
//
// This software is released under the GNU General Public License version 3,
// which covers the main part of arduino-cli.
// The terms of this license can be found at:
// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// You can be released from the requirements of the above licenses by purchasing
// a commercial license. Buying such a license is mandatory if you want to
// modify or otherwise use the software for commercial activities involving the
// Arduino software without disclosing the source code of your own applications.
// To purchase a commercial license, send an email to license@arduino.cc.

package preprocessor

import (
	"bytes"
	"fmt"
	"testing"

	"github.com/arduino/arduino-cli/internal/arduino/sketch"
	"github.com/arduino/go-paths-helper"
	"github.com/stretchr/testify/require"
)

func TestCtagsSketchFilter(t *testing.T) {
	sourcePath := paths.New("testdata", "sketch_merged.cpp")
	f, err := sourcePath.Open()
	require.NoError(t, err)
	t.Cleanup(func() { f.Close() })

	sketch := &sketch.Sketch{
		MainFile: paths.New("/home/megabug/Arduino/Test/Test.ino"),
	}
	stderr := bytes.NewBuffer(nil)
	res := filterSketchSource(sketch, f, false, stderr)
	require.Empty(t, stderr)
	require.NotEmpty(t, res)
	fmt.Println(res)
}
