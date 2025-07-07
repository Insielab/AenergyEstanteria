import { NextResponse } from "next/server";
import fs from "fs";
import path from "path";

export async function GET() {
  const fichasDir = path.join(process.cwd(), "public", "fichas");

  let fichas: any[] = [];

  try {
    const files = fs.readdirSync(fichasDir);

    fichas = files
      .filter((file) => file.endsWith(".json"))
      .map((file) => {
        const filePath = path.join(fichasDir, file);
        const json = JSON.parse(fs.readFileSync(filePath, "utf8"));
        return {
          folio: json.folio,
          titulo: json.titulo,
          autor: json.autor,
          url: `/fichas/${file}`,
        };
      });
  } catch (e) {
    console.error("Error reading fichas:", e);
  }

  return NextResponse.json({ fichas });
}
