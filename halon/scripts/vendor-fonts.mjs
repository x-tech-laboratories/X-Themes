#!/usr/bin/env node
// Copies Noto Sans from an unpacked @fontsource-variable/noto-sans package into web/fonts/, with its licence and a
// manifest that scripts/build-web.mjs turns into the @font-face rules of halon-tokens.css.
//
// Usage:
//   npm pack @fontsource-variable/noto-sans@<version> && tar xzf fontsource-variable-noto-sans-<version>.tgz
//   node scripts/vendor-fonts.mjs package

import { createHash } from "node:crypto";
import { copyFileSync, mkdirSync, readdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = process.env.HALON_ROOT ?? join(dirname(fileURLToPath(import.meta.url)), "..");
const package_folder = process.argv[2];
if (!package_folder) throw new Error("usage: node scripts/vendor-fonts.mjs <unpacked @fontsource-variable/noto-sans folder>");

// The scripts the apps and sites write in; Devanagari has its own Noto family and is left to the system.
const subsets = ["latin", "latin-ext", "greek", "greek-ext", "cyrillic", "cyrillic-ext", "vietnamese"];

// ============================================================================
// Read the package
// ============================================================================

const package_json = JSON.parse(readFileSync(join(package_folder, "package.json"), "utf8"));
if (package_json.name !== "@fontsource-variable/noto-sans") throw new Error(`${package_folder} holds ${package_json.name}, not @fontsource-variable/noto-sans`);

// Each face in Fontsource's sheet for the weight axis, by the file it points at.
function read_faces(sheet) {
  const faces = new Map();
  for (const match of readFileSync(join(package_folder, sheet), "utf8").matchAll(/@font-face\s*{([^}]*)}/g)) {
    const file = match[1].match(/url\(\.\/files\/([^)]+)\)/)[1];
    faces.set(file, { style: match[1].match(/font-style:\s*(\w+)/)[1], unicode_range: match[1].match(/unicode-range:\s*([^;]+);/)[1].trim() });
  }
  return faces;
}

const faces_by_file = new Map([...read_faces("wght.css"), ...read_faces("wght-italic.css")]);

// ============================================================================
// Copy
// ============================================================================

const fonts_folder = join(root, "web/fonts");
mkdirSync(fonts_folder, { recursive: true });
for (const name of readdirSync(fonts_folder)) if (name.endsWith(".woff2")) rmSync(join(fonts_folder, name));

// Kept in Fontsource's order, since where two ranges overlap the face declared last wins.
const faces = [];
for (const [file, face] of faces_by_file) {
  const subset = file.match(/^noto-sans-(.+)-wght-\w+\.woff2$/)[1];
  if (!subsets.includes(subset)) continue;
  copyFileSync(join(package_folder, "files", file), join(fonts_folder, file));
  const sha256 = createHash("sha256").update(readFileSync(join(fonts_folder, file))).digest("hex");
  faces.push({ file, subset, style: face.style, unicode_range: face.unicode_range, sha256 });
}
const missing = subsets.filter((subset) => faces.filter((face) => face.subset === subset).length !== 2);
if (missing.length) throw new Error(`the package lacks a normal or italic face for ${missing.join(", ")}`);

copyFileSync(join(package_folder, "LICENSE"), join(fonts_folder, "OFL.txt"));

const manifest = { family: "Noto Sans", source: `${package_json.name}@${package_json.version}`, license: "OFL-1.1", weights: "100 900", faces };
writeFileSync(join(fonts_folder, "noto-sans.json"), `${JSON.stringify(manifest, null, 2)}\n`);
console.log(`Copied ${faces.length} faces of ${manifest.source} into ${fonts_folder}`);
